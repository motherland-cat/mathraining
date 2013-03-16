# == Schema Information
#
# Table name: exercises
#
#  id         :integer          not null, primary key
#  statement  :text
#  decimal    :boolean          default(FALSE)
#  answer     :float
#  chapter_id :integer
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Exercise < ActiveRecord::Base
  attr_accessible :answer, :chapter_id, :decimal, :statement, :position
  belongs_to :chapter
  validates :statement, presence: true, length: {maximum: 8000 }
  validates :answer, presence: true
  validates :position, presence: true
end