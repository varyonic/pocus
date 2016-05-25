module Pocus
  # https://www.icontact.com/developerportal/documentation/segments
  class Segment < Resource
    self.path = :segments
    self.primary_key = :segment_id

    has_many :criteria, class: 'SegmentCriteria'
  end
end
