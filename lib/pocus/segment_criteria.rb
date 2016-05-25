module Pocus
  # https://www.icontact.com/developerportal/documentation/segment-criteria
  class SegmentCriteria < Resource
    self.path = :criteria
    self.primary_key = :criterion_id

    def self.tag_multiple
      'criteria'
    end
  end
end
