class Department < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :articles
  belongs_to :sector
end
