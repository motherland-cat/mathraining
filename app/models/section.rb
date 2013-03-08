# == Schema Information
#
# Table name: sections
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Section < ActiveRecord::Base
  attr_accessible :description, :name, :image
  validates :name, presence: true, length: { maximum: 255 }, uniqueness: true
  validates :description, length: {maximum: 8000 }
end
