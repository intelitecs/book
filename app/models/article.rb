class Article < ActiveRecord::Base
  default_scope{ order('created_at DESC')}
  has_attached_file :image, styles: {small:'200x150',medium:'400x350>', large: '600x500>'}
  has_many :comments, dependent: :destroy
  has_many :users, through: :comments



end
