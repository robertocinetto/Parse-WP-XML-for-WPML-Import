require 'rubygems'
require 'nokogiri'
require 'json'
require 'pp'

@doc = Nokogiri::XML(File.read("content.xml"))
@doc_it = Nokogiri::XML
@doc_en = Nokogiri::XML
@doc_fr = Nokogiri::XML

translation_file = File.read('translation.json')
translations = JSON.parse(translation_file)

new_id = 2000;

translations['data'].group_by{ |trid| trid['trid'] }.each do |key, trid| 
  #array di trid con hash di progetti riferiti allo stesso trid
  puts "\n\n"
  trid.each do |project_group|
    #hash di progetti con stesso trid
    pp project_group['trid']
    pp element_id = "#{project_group['element_id']}"
    pp language = "#{project_group['language_code']}"

    @doc.xpath("//item//wp:post_id[text() = " + element_id + "]").each do |post_id_element|
      post_id_element.content = new_id
      pp post_id_element.content
      case language
      when "it"
        @doc_it << post_id_element.parent.to_xml
      when "en"
        @doc_en << post_id_element.parent.to_xml
      when "fr"
        @doc_fr << post_id_element.parent.to_xml
      else

      end
    end

    pp new_id
  end
  new_id += 1
end

# post_id = @doc.xpath('//item//wp:post_id[contains(text(), "757")]')
# post_id.content = "ciao mamma"
# pp id
# element_id_test = "757";
# @doc.xpath("//item//wp:post_id[contains(text(), " + element_id_test + ")]").each do |post_id_element|
#   post_id_element.content = "ciao mamma"
# end

# @doc.xpath("//item//wp:post_id[text() = " + "436" + "]").each do |post_id_element|
#   post_id_element.content = new_id
#   pp post_id_element.content
# end

file = File.new 'content_result_it.xml', 'wb'
file.write(@doc_it)
file.close
file = File.new 'content_result_en.xml', 'wb'
file.write(@doc_en)
file.close
file = File.new 'content_result_fr.xml', 'wb'
file.write(@doc_fr)
file.close


