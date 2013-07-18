require 'savon'

class Event < ActiveRecord::Base

  Api_url = 'http://events.scottish-enterprise.com/eventsservice/EventsWebService.svc?wsdl'

  attr_accessible :description, :event_id, :title

  def self.update_from_api
    begin
      last_successfull_update_time = EventUpdate.last_successfull_time || Time.new('2013/07/07')
      time_str = last_successfull_update_time.strftime('%FT%T')
      updated_at = Time.now
      client = Savon.client(wsdl: Api_url, element_form_default: :qualified, env_namespace: 'SOAP-ENV')
      response = client.call(:get_all_events_by_date, message: { dtLastUpdate: time_str })

      if response && response.body
        we_need_to_go_deeper = response.body
        [:get_all_events_by_date_response,
         :get_all_events_by_date_result,
         :diffgram,
         :new_data_set,
         :table].each do |key|
          we_need_to_go_deeper = we_need_to_go_deeper[key]
          break unless we_need_to_go_deeper
        end
        events_data = we_need_to_go_deeper
      end

      if events_data
        values = []
        events_data.each do |event_data|
          values << '(' +
          [ActiveRecord::Base.sanitize(event_data[:event_id]),
           ActiveRecord::Base.sanitize(event_data[:title]),
           ActiveRecord::Base.sanitize(event_data[:description]),
           ActiveRecord::Base.sanitize(event_data[:date_start]),
           ActiveRecord::Base.sanitize(event_data[:date_end]),
           'NOW()',
           'NOW()'].map{|val| "#{val}"}.join(', ') +
          ')'
        end

        values_str = values.join(', ')

        sql = "INSERT INTO events (id, title, description, date_start, date_end, updated_at, created_at)
               VALUES #{values_str}
               ON DUPLICATE KEY UPDATE title = title,
                                       description = description,
                                       date_start = date_start,
                                       date_end = date_end,
                                       updated_at = NOW(),
                                       created_at = created_at"

        ActiveRecord::Base.connection.execute(sql)
        records = events_data.size
      else
        records = 0
      end

    rescue Exception => e
      message = e.message
    ensure
      EventUpdate.create(message: message, updated_at: updated_at, records: records)
    end
  end

  def self.from_to(date_start, date_end)
    where('date_start >= ? AND date_start <= ?', date_start.to_time, date_end.to_time)
  end

end
