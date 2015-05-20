class MainController < ApplicationController
  def main
  end
  def graph
  end
  def data
    data= {:nodes => [], :links => []}
    term = Term.first
    data[:nodes] << {id:term.id, label:term.term}
    term.related_terms.each_with_index  do |rt,index|
      data[:nodes]<< {id:rt.id, label:rt.term}
      data[:links]<< {source:0, target:index+1}
      if index > 5
        break
      end
    end
    p data
    render json:data
  end


  def test_data
    n =<<EOS
node,0,田中
node,1,三木
node,2,大平
node,3,福田
node,4,中曽根
node,5,鈴木
node,6,竹下
EOS
    l =<<EOS
link,0,1
link,0,2
link,0,3
link,3,4
link,3,5
link,4,5
link,4,6
EOS
    nodes = []
    n.each_line do |line|
      elems = line.chomp.split(",")
      nodes.push({id:elems[1].to_i, label:elems[2]})
    end

    links = []
    l.each_line do |line|
      elems = line.chomp.split(",")
      links.push({source:elems[1].to_i,target:elems[2].to_i})
    end
    data = {nodes:nodes, links:links}
    p data
    render json: data
  end
end
