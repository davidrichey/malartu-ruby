module Malartu
  module Tracking
    # Tracking::Data lets you store data is the Malartu system
    class Data < MalartuObject
      def self.create(topic: nil, value: 1)
        fail 'No topic' if topic.nil?
        res = Malartu.request('post', '/kpi/tracking/data', topic: topic, value: value)
        Malartu::Tracking::Data.new(res)
      end

      def self.find(id)
        fail 'No ID given' if id.nil?
        path = "/kpi/tracking/data/#{id}"
        res = Malartu.request('get', path)
        Malartu::Tracking::Data.new(res)
      end

      def self.list(starting:, ending:, page: 1, paginate: false, topic: nil)
        params = { starting: starting, ending: ending, topic: topic, page: page }.select { |_, value| !value.nil? }
        res = Malartu.request('get', '/kpi/tracking/data', params)
        data = res['data'].map do |datum|
          Malartu::Tracking::Data.new(datum)
        end
        page = res["page"].to_i
        return data unless paginate?(res)
        # Paginated requests
        res = Malartu.request('get', '/kpi/tracking/data', params.merge(page: page + 1))
        data + res['data']
      end

      def self.update(id, topic: nil, value: 1)
        fail 'No Topic' if topic.nil?
        params = {}
        params[:topic] = topic unless topic.nil?
        params[:value] = value unless value.nil?
        fail 'No parameters to send' if params == {}
        path = "/kpi/tracking/data/#{id}"
        res = Malartu.request('patch', path, params)
        Malartu::Tracking::Data.new(res)
      end
    end
  end
end
