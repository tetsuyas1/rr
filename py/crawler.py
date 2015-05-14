#CINIIからデータをクロールするスクリプト
# writtern by tetsuyas(Tetsuya SATO)

# import xml.etree.ElementTree as etree
import json,time,re
import urllib.request
import urllib.parse

#RDF定義
__rss = "{http://purl.org/rss/1.0/}"
__dc  = "{http://purl.org/dc/elements/1.1/}"

#crawl_data_dir = "data/crawl_results/" #しばらく使わない予定
 crawl_data_filename = "../data/var/crawl.json"

hiragana = re.compile(r"[ぁ-ん]+")

__total_doc_size = 10000
__size_per_access = 200
__interval_sec = 10

__crawled_list = []
__crawled_title_list = []

__keywords = ["研究","調査","学"]#この単語を含む論文を収集
__empty_crawl_count = 0
__desc_text_size = 200  #クロールする最低文字数
__jap = re.compile(r"[ぁ-ん]+")

#クロールする対象かどうか判定
def __is_target(item):
  title = item.find(__rss+"title").text
  if title in __crawled_title_list:
    return False
  desc = item.find(__rss+"description")
  return desc is not None \
         and len(desc.text) > __desc_text_size \
         and __jap.search(desc.text) is not None

#XMLから、取得すべき文書のリストを返却
def __getItems(root,max = 200):
  print("call getItems max=%i" % max)
  _list = []
  for item in root.findall(__rss+"item"):
    if __is_target(item):
      _item = {}
      _item["title"] = item.find(__rss+"title").text
      _item["link"] = item.find(__rss+"link").text
      creators = item.findall(__dc+"creator")
      _item["authers"] = [c.text for c in item.findall(__dc+"creator")]
      _item["publisher"] = item.find(__dc+"publisher").text
      _item["description"] = item.find(__rss+"description").text
      _item["date"] = item.find(__dc+"date").text
      _list.append(_item)
    if len(_list) >= max:
      break
  return _list

#キーワードを含む論文を取得し、パースして返却
def __get_xml_tree(start,count,keyword):
  encoded_keyword = urllib.parse.quote(keyword)
  url = "http://ci.nii.ac.jp/opensearch/search?q="+encoded_keyword+"&count="+str(count) \
        +"&start="+str(start*count)+"&lang=ja&title=&author=&affiliation=&journal=" \
        +"&issn=&volume=&issue=&%20page=&publisher=&references=&year_from=&year_to=&range=1&sortorder=&format=rss"
  html = urllib.request.urlopen(url)
  tree = etree.parse(html)
  return tree

def save_dumped_list(list,name):
  file = open(name,"w")
  file.write(json.dumps(list,ensure_ascii=False,indent=2, separators=(',', ': ')))
  file.close()


def crawl():
  __start = 0
  __keyword_id = 0
  __empty_crawl_count = 0
  while(True):

    print("call url %s %i " % (__keywords[__keyword_id],__start))
    try:
      __tree = __get_xml_tree(__start,__size_per_access,__keywords[__keyword_id])
    except:
      save_dumped_list(__crawled_list,crawl_data_filename)
      return

    items = __getItems(__tree.getroot())

    __start = __start + 1
    for elem in items:
      __crawled_list.append(elem)
      __crawled_title_list.append(elem["title"])
      #save_dumped_list(items, crawl_data_dir+__keywords[__keyword_id]+"_"+str(__start)+".json" )

    print("interval = %i" % __interval_sec)
    time.sleep(__interval_sec)

    if len(items) == 0:
      __empty_crawl_count = __empty_crawl_count + 1

    print("itemsの数は %i でした。" % len(items))

    if __empty_crawl_count > 3:
      __keyword_id = __keyword_id + 1
      __start = 0
      __empty_crawl_count = 0
      if __keyword_id >= len(__keywords):
        print("キーワードが終了しました。")
        break
      else:
        print("結果が０となるクエリが３回連続したので次のキーワード[%s]を試みます。" % __keywords[__keyword_id])

    if len(__crawled_list) > __total_doc_size:
      print("目標数を超えました。")
      break

  save_dumped_list(__crawled_list,crawl_data_filename)

def samp():
  print(hiragana.search("aaaa"))
  print(hiragana.search("あああ"))
  if True :
    return

  for key in __keywords:
    print(urllib.parse.quote(key))

if __name__ == "__main__":
  print("クロールするにはコメントアウトを外してください。")
  #samp()
  #crawl()
