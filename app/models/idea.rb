require 'supervision_part'
require 'rateable'

class Idea < ActiveRecord::Base
  include SupervisionPart
  include Rateable

  validates_presence_of :content
end
