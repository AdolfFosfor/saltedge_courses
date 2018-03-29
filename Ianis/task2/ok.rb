require "watir"

class Odnoklassniki

  attr_reader :browser
  def initialize
    @browser = Watir::Browser.new :chrome
    browser.goto("google.com")
    sleep(1)
  end

  def collect_links
    search_person
    return unless present_photo?
    take_photo
    { links: take_links }
  end

  def search_person
    browser.text_field(id: "lst-ib").set("Иван Петров" + " одноклассники")
    browser.input(name: "btnK").click
    sleep(1)
    browser.div(class: "srg").links[0].click
  end

  def take_photo
    browser.ul(class: "recent-bar_cnt").links[0].click
    sleep(2)
  end

  def take_links
    photo = []
    3.times {
      photo << browser.div(id: "photo-layer_img_w").image.attribute_value("src").to_s
      browser.span(id: "plsp_next").click
      sleep(1)
    }
    photo.uniq
  end

  def present_photo?
    browser.ul(class: "recent-bar_cnt").present?
  end
end

ok = Odnoklassniki.new
puts ok.collect_links