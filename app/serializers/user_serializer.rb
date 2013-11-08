class UserSerializer < ActiveModel::Serializer
  attributes :id, :done, :username, :email
end
