# Имплементация метода import

class Item < ActiveRecord::Base
  
  # не обновляет аттрибуты товаров, которых нет в наличии
  def self.import items
    items.each do |attrs|
      item_found = find_or_initialize_by(partner_item_id: attrs[:partner_item_id])
      if item_found.new_record? or attrs[:available_in_store]
        item.update_attributes attrs
      else
        item.update_attribute 'available', false
      end
    end
  end
  
end
