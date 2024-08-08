class CategorySerializer < ActiveModel::Serializer
  attributes :id, :title, :subItems

  def title
    object.name
  end

  def subItems
    object.subcategories.map do |subcategory|
      CategorySerializer.new(subcategory, scope: scope, root: false)
    end
  end

end
