class Code < ApplicationRecord
  belongs_to :submission
  belongs_to :test
end
