class MainController < ApplicationController
  def main
  end
  def graph
    p params["term"]
    @graph_data = {
        :nodes => [{id:1,term:"a1"},
                    {id:2,term:"a2"},
                    {id:3,term:"a3"}],
        :links => [[1,2],[2,3]]}
    p @graph_data
  end
end
