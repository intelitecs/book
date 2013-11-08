class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :done
end
