require 'net/http'

class MainController < ApplicationController

  def index

  end

  def labels
    respond_to do |format|
      url = URI.parse('http://localhost:7474/db/data/labels')
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port) { |http|
        http.request(req)
      }
      format.html { render :new }
      format.json { render text: res.body, status: :ok }
    end
  end

end
