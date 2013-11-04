# Имплементация метода import

class Item < ActiveRecord::Base
  def self.import items
    # Из гема https://github.com/seamusabshere/upsert
    # Производит insert или update уже существующих записей. 
    # Работает напрямую с адаптерами, минуя ActiveRecord, тем самым ускоряя процесс. 
    Upsert.batch(connection, :items) do |upsert|
      items.each { |attrs| upsert.row(:partner_item_id, attrs) }
      # Для postgres внутри раскрывается в подобный запрос: 
      # http://www.postgresql.org/docs/9.1/static/plpgsql-control-structures.html#PLPGSQL-UPSERT-EXAMPLE
      # Вырезка из гема:
      # https://github.com/seamusabshere/upsert/blob/dfeb16ef8e0dfd2d018955848ad8a31d49478908/lib/upsert/merge_function/postgresql.rb#L103
    end
  end
end
