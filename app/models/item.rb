# == Schema Information
#
# Table name: items
#
#  id         :bigint           not null, primary key
#  calories   :integer
#  carbs      :integer
#  comment    :text
#  fat        :integer
#  photo      :string
#  protein    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Item < ApplicationRecord
end
