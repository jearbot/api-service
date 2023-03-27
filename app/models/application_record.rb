class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.find(id)
    # custom implementation of find method to make finding things easier with external ids
    # so you don't have to type "Foo.friendly.find(id)" over and over again
    self.friendly.find(id)
  end
end
