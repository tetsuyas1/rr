require 'json'

namespace :models do

  models  = {
    author:"name:string stripped:string section:string sub_section:string birthday:date",
    term:"term:string",
    author_term:"author:references term:references weight:float",
    term_relation:"term_a_id:integer term_b_id:integer  weight:float",
    author_relation:"author_a_id:integer author_b_id:integer weight:float",
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

  desc "load"
  task :load => :environment do
    dir = Rails.root.join("../data/latest/")

    terms = JSON.parse(open(dir+"terms.json").read)
    p terms[0]
    p terms.size

    relational_word = JSON.parse(open(dir+"relational_words.json").read)
    p relational_word.size
    p relational_word[0]

    articles = JSON.parse(open(dir+"articless.json").read)

    p articles.size


  end

  desc "Test"
  task :test do
    s = {id:123, name:'Tetsuya'}
    p JSON.dump(s)
    st = "{\"id\":123,\"name\":\"Tetsuya\"}"
    p JSON.parse(st)
  end
end
