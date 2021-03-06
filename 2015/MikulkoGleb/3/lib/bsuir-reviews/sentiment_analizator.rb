require 'mechanize'

class SentimentAnalizator
  SITE_URL = 'http://sentistrength.wlv.ac.uk/#About'
  RUSSIAN_FORM_NUMBER = 7
  XPATH_POSITIVE = "/html/body/div[@class='container']
                   /div[@class='content']/p[2]
                   /span[@class='ExecutiveSummary']/b[1]"
  XPATH_NEGATIVE = "/html/body/div[@class='container']
                   /div[@class='content']/p[2]/
                   span[@class='ExecutiveSummary']/b[2]"

  def initialize
    @agent = Mechanize.new
  end

  def analyze(text)
    page = get_page(text)
    positive_rating = page.search(XPATH_POSITIVE).text.to_i
    negative_rating = page.search(XPATH_NEGATIVE).text.to_i
    positive_rating + negative_rating
  rescue => e
    abort(e.inspect)
  end

  def get_page(text)
    page = @agent.get(SITE_URL)
    forms = page.forms_with
    russian_form = forms[RUSSIAN_FORM_NUMBER]
    russian_form['text'] = text
    @agent.submit(russian_form, russian_form.buttons.first)
  rescue => e
    abort(e.inspect)
  end
end
