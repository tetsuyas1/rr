require 'json'

namespace :models do

  models  = {
    author:"name:string stripped:string section:string sub_section:string birthday:date",
    term:"term:string",
    author_term:"author:references term:references weight:float",
    term_relation:"term_id:integer related_term_id:integer  weight:float",
    author_relation:"author_id:integer related_author_id:integer weight:float",
    article:"title:string description:text ",
    article_author:"article:references author:references",
    article_term:"article:references term:references"
  }

  desc "マイグレーションを生成する。"
  task g: :environment do |t,args|
    skipparams = " --skip-assets --skip-helper --skip-stylesheets --skip-view-specs --skip-controller-specs"+
        " --skip-routing-specs --skip-request-specs --skip-jbuilder --no-test-framework"
    models.each do |k,v|
      p `bundle exec rails g scaffold #{k.to_s} #{v.to_s} #{skipparams}`
    end
  end

  desc "モデル設定を削除"
  task d: :environment do
    models = ["author","term","author_term","term_relation","author_relation","article","article_author","article_term"]
    models.each do |k,v|
      p `bundle exec rails d scaffold #{k.to_s}`
    end
  end

  def dir
    Rails.root.join("../data/latest_3/")
  end


  desc "load"
  task :load do
    Rake::Task["db:migrate:reset"].invoke()
    Rake::Task["models:load_terms"].invoke();
    Rake::Task["models:load_relational_words"].invoke();
    Rake::Task["models:load_articles"].invoke();
  end


  def measure_time
    s = Stopwatch.new
    yield
    s.elapsed_time
  end

  task :load_articles => :environment do
    measure_time do
      articles = JSON.parse(open(dir+"articles.json").read)
      article_objs = []
      article_author_objs = []
      article_terms_objs =[]
      authors_objs = []
      authors_relation_objs = []

      articles.each do |a|
        article_objs << Article.new(id:a["id"],title:a["title"], description:a["description"])
      end

      Article.import article_objs

      articles.each do |a|
        #p "size = #{a["authors"].size}"
        for i in 0...a["authors"].size do
          author = a["authors"][i]
          authors_objs << Author.new(id:author["id"],name:author["origin"],stripped:author["stripped"] )
          article_author_objs << ArticleAuthor.new(article_id:a["id"], author_id:author["id"])
          for j in i...a["authors"].size do
            another_author = a["authors"][j]
            authors_relation_objs<< AuthorRelation.new(author_id:author["id"], related_author_id:another_author["id"])
            authors_relation_objs<< AuthorRelation.new(author_id:another_author["id"], related_author_id:author["id"])
          end
        end

        for k in 0...a["keywords"].size do
          article_terms_objs << ArticleTerm.new({term_id: a["keywords"][k]["id"], article_id:a["id"]})
        end

      end
      pp authors_objs
      pp article_author_objs

      Author.import authors_objs
      ArticleAuthor.import article_author_objs
      AuthorRelation.import authors_relation_objs
      ArticleTerm.import article_terms_objs
      p "articles = #{Article.count} . a_author=#{ArticleAuthor.count}"
      p "authors = #{Author.count} AuthorRelation = #{AuthorRelation.count}"
      p "article_terms = #{ArticleTerm.count}"
    end
  end

  task :load_relational_words => :environment do
    measure_time do
      relational_word = JSON.parse(open(dir+"relational_words.json").read)
      list = []
      relational_word.each do |r|
        list << TermRelation.new(term_id:r[0]["id"], related_term_id:r[1]["id"])
        list << TermRelation.new(term_id:r[1]["id"], related_term_id:r[0]["id"])
      end
      TermRelation.import list
      p "#{TermRelation.count} TermRelation instances are loaded."
    end
  end

  task :load_terms => :environment do
    measure_time do
      list = []
      terms = JSON.parse(open(dir+"terms.json").read)
      terms.each do |t|
        list << Term.new(t)
      end
      Term.import list
      p "#{Term.count} Term instances are loaded."
    end
  end

  desc "Test"
  task :test do

    for i in  0..3 do
      p i
    end
  end

  desc "Test"
  task :jsontest do
    s = {id:123, name:'Tetsuya'}
    p JSON.dump(s)
    st = "{\"id\":123,\"name\":\"Tetsuya\"}"
    p JSON.parse(st)
  end
end

class Stopwatch

  def initialize()
    @start = Time.now
  end

  def elapsed_time
    now = Time.now
    elapsed = now - @start
    puts 'Started: ' + @start.to_s
    puts 'Now: ' + now.to_s
    puts 'Elapsed time: ' +  elapsed.to_s + ' seconds'
    elapsed.to_s
  end

end