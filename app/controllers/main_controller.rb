require 'net/http'

class MainController < ApplicationController

  def index

  end

  def nodes
    url = URI.parse('http://localhost:7474/db/data/labels')
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) { |http|
      http.request(req)
    }
    
    # get children
    # match (a:Города)<-[r2]-(b) return distinct labels(startNode(r2)), type(r2), labels(endNode(r2))
    
    # get children tree
    # match (a:Города)<-[r*]-(b) unwind r as r2 return distinct labels(startNode(r2)), type(r2), labels(endNode(r2))
    # match (a:Tag {name:'Адреса'})<-[r*]-(b) unwind r as r2 return distinct labels(startNode(r2)), type(r2), labels(endNode(r2))
    respond_to do |format|
      format.html { render :new }
      format.json { render text: res.body, status: :ok }
    end
  end

end
