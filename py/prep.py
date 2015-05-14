# 第一引数に読み込む指定形式のjsonファイル名,読み込む対象数を設定
# 事前処理を行うスクリプト

import sys,json,os
from datetime import datetime
import re
import MeCab
from nltk.text import TextCollection
import numpy as np


#default values
__save_data_dir = None
read_json_file = "../data/crawl.json"
#size = None
size = 3
#size = 1000

tagger = MeCab.Tagger('-Ochasen')

KEYWORD_SIZE = 10
NOT_CORRECT_RE = ["^[!-/:-@≠\[-`{-~「」『』<>]+$","^[!-@≠\[-`{-~]{1,3}$","^$","^[ぁ-ん]{1}$"]
Patterns = []

KEYWORD_JACCARD_THRESHOLD = 0.1

for r in NOT_CORRECT_RE:
  Patterns.append(re.compile(r))

#=====================

def __save_json(filename,obj):
  file = open(filename,"w")
  file.write(json.dumps(obj,ensure_ascii=False,indent=2, separators=(',', ': ')))
  file.close()

def __is_count_node(node):
  if node.feature.split(",")[0] != "名詞":
    return False
  for p in Patterns:
    try:
      if p.match(node.surface):
        return False
    except:
      print("RuntimeError "+str(node))
      return False
  return True

def __tokens(text):
  node = tagger.parseToNode(text)
  __tokens = []
  while node:
    if __is_count_node(node):
      try:
        __tokens.append(node.surface)
      except:
        print("RuntimeError "+str(node))
    node = node.next
  return __tokens

#ジャガード係数を計算する
#v1,v2は0と１を要素に持つ同じ長さのベクトル 例) [0,1,1,0,1]
def __jaccard(v1,v2):
  if len(v1) != len(v2):
    raise Exception()
  dot = np.dot(v1,v2)
  floor = v1.sum()+v2.sum()+dot
  if floor !=0:
    return float(dot)/floor
  else:
    return 0

def refresh_link(dist,link):
  if os.path.exists(link):
    os.remove(link)
  os.symlink(dist,link)

###########################
if __name__ == "__main__":
  if len(sys.argv) > 1:
    if sys.argv[1] != "0":
        read_json_file = sys.argv[1]
  if len(sys.argv) > 2:
    if sys.argv[2] != "0":
        size = int(sys.argv[2])

  target_dir = datetime.now().strftime('%Y%m%d_%H%M%S')
  __save_data_dir = "../data/var/%s/" % target_dir
  os.makedirs(__save_data_dir)

  refresh_link(__save_data_dir,"../data/latest")
  link = None
  if size is  None:
    refresh_link(__save_data_dir,"../data/latest_max")
  else:
    refresh_link(__save_data_dir,("../data/latest_%i" % size))

  print("###########################")
  print("# START prep.py with argv = '%s' " %sys.argv[1:])
  print("###########################")

#重複を排除して、指定数読み込む
  loaded_articles = {}
  for doc in json.loads(open(read_json_file,"r").read()):
    loaded_articles[doc["title"]] = doc
    if size is not None and len(loaded_articles) >= size:
      break

  print("loaded %i articles" % len(loaded_articles))

#出現する著者、descriptionの単語をまとめる。

  articles = []
  all_tokens = []
  all_striped_author_names = set()
  for doc in loaded_articles.values():
    #id
    doc["id"] = len(articles)+1
    #authors
    auth_dics = []
    for a in doc["authors"]:
      auth_dic = {"origin":a}
      striped = a.replace(" ","").replace("　","")
      auth_dic["stripped"] = striped
      all_striped_author_names.add(striped)
      auth_dics.append(auth_dic)

    doc["authors"] = auth_dics

    #token
    tokens = __tokens(doc["description"])
    doc["tokens"]= tokens
    all_tokens.append(tokens)
    articles.append(doc)

  #全ての単語を集計
  collection = TextCollection(all_tokens)
  all_terms = list(set(collection))

  terms_with_id = [ {'id':i+1, "term":all_terms[i]}  for i in range(0,len(all_terms))]
  __save_json(__save_data_dir+"terms.json",terms_with_id)

  #TFIDFを計算、単語の各文書での出現頻度をを計算
  tfidf_vec =[]
  count = 0
  for tokens in all_tokens:
    vec = []
    for term in all_terms:
      vec.append(collection.tf_idf(term, tokens))
    tfidf_vec.append(vec)
    count  = count + 1
    if (count % 100) == 0:
      print("now processing at %i" % count)
  print("total vectors row = %i" % count)
  np.savetxt(__save_data_dir+"tfidf_vectors.csv",tfidf_vec,delimiter=",")
  word_cooccurrence = np.array([[1 if 0 < a11 else 0 for a11 in a1 ]for a1 in np.array(tfidf_vec).T])
  np.savetxt(__save_data_dir+"word_corccurrence.csv",word_cooccurrence,delimiter=",")
  wc = word_cooccurrence

  print("#start Jaccard ")
  #ジャガード係数の計算
  jaccard_matrix = np.zeros([len(wc),len(wc)])
  relational_words = []
  for i in range(0,len(wc)):
    for j in range(i+1,len(wc)):
      jac = __jaccard(wc[i],wc[j])
   #   jaccard_matrix[i,j] = jac
   #fa   jaccard_matrix[j,i] = jac
      if jac > KEYWORD_JACCARD_THRESHOLD:
        relational_words.append([{'id':i+1,'term':all_terms[i]},{'id':j+1,'term':all_terms[j]}])

  __save_json(__save_data_dir+"relational_words.json",relational_words)
  #np.savetxt(__save_data_dir+"jaccard_matrix.csv",jaccard_matrix,delimiter=",",fmt="")

  #キーワードの付与
  for i in range(0,len(tfidf_vec)):
    vec = np.array(tfidf_vec[i])
    keywords = []
    terms = []
    for k in range(1,1+KEYWORD_SIZE):
      term_id = vec.argsort()[k*(-1)]
      term = all_terms[term_id]
      print("%s %i" % (term, int(term_id)))
      keyword = {"term":term,"id":int(term_id)+1 }
      keywords.append(keyword)
    articles[i]["keywords"] = keywords

  #著者,keywordsの名寄せ、idの付与
  keywords = []
  authors = []
  all_striped_author_names = list(all_striped_author_names)
  for article in articles:
    for author in article["authors"]:
      author["id"] = all_striped_author_names.index(author["stripped"])

  __save_json(__save_data_dir+"authors.json",all_striped_author_names)
  __save_json(__save_data_dir+"articles.json",articles)


