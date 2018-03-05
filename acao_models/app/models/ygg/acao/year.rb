#
# Copyright (C) 2017-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Year < Ygg::PublicModel
  self.table_name = 'acao_years'

  def self.renew_for_year
    (Time.now + 10.month).year
  end

  def self.renewal_year
    find_by(year: renew_for_year)
  end

  def beginning_time
    # The membership year starts from the day the renewals are open
    renew_for_year
  end

  def ending_time
    # The membership year ends on 31st January of the next year
    Time.new(year).end_of_year + 31.days
  end
end

end
end
