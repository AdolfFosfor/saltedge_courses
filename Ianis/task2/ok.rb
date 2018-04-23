require "watir"

class Odnoklassniki

  attr_reader :browser
  def initialize
    @browser = Watir::Browser.new :chrome
    browser.goto("google.com")
    page_ready?
  end

  def collect_links
  search_person
  return unless present_photo?
  open_photo
  [ take_links ]
end

def search_person
  browser.text_field(id: "lst-ib").set("Иван Петров" + " одноклассники")
  browser.input(name: "btnK").click
  browser.div(class: "srg").links[0].click
end

def open_photo
  browser.ul(class: "recent-bar_cnt").links[0].click
  page_ready?
end

def take_links
  photo = []
  3.times {
    sleep(1)
    photo << browser.div(id: "photo-layer_img_w").image.attribute_value("src").to_s
    browser.span(id: "plsp_next").click
  }
end

def page_ready?
  browser.wait unless browser.ready_state.eql? "complete"
end

def present_photo?
  browser.ul(class: "recent-bar_cnt").present?
end
end
ok = Odnoklassniki.new
puts ok.collect_links