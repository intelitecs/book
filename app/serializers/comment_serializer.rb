class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :done
  has_one :user
  has_one :article
end
