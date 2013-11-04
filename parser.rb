# Псевдокод тестового задания на Ruby

require 'nokogiri'
require 'active_record'

ITEM_ATTRIBUTES = %w(title)


class YandexMarket < Nokogiri::XML::SAX::Document
  
  # Пример XML
  # <items>
  #   <item available=”true” id=”123”>
  #     <title>Рубашка</title>
  #   </item>
  # </items>
  
  # После парсинга: instock => [{partner_item_id: integer, title: string}, ...]
  attr_reader :in_stock
  
  def initialize
    @items = []
  end
  
  def start_element name, attrs
    attrs = Hash[attrs.flatten]
    if name == 'item'
      attrs[:partner_item_id] = attrs[:id]
      attrs.delete(:id)
      @item = attrs
    elsif name.in? ITEM_ATTRIBUTES
      @watch_attribute = name
    end
  end
  
  def end_element name
    if name == 'item'
      @items.push @item
    end
  end
  
  def characters text
    if @watch_attribute
      @item[@watch_attribute] = text
    end
  end
  
end


class StockParser
  def initialize partner
    @parse = partner[:xml_type].constantize.new
    @partner_id = partner[:id]
    Nokogiri::HTML::SAX::Parser.new(@parse).parse_file(partner[:xml_url])
  end
  
  def import
    items = @parse.items.map do |attrs|
      attrs[:partner_id] = @partner_id
      attrs[:available_in_store] = true
    end
    Item.import items
  end
end

# Инициализация
StockParser.new(xml_type: 'YandexMarket', xml_url: './file.xml', id: 14)
StockParser.parse
