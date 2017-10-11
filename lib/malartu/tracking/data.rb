module Malartu
  module Tracking
    # Tracking::Data lets you store data is the Malartu system
    class Data
      attr_accessor :id, :topic, :value, :path, :json_body
      def initialize(id: nil, topic: nil, value: 1, path: nil, json_body: {})
        @id = id
        @topic = topic
        @value = value
        @path = path
        @json_body = json_body
      end

      def self.create(topic: nil, value: 1)
        fail 'No topic' if topic.nil?
        res = Malartu.request('post', '/kpi/tracking/data', topic: topic, value: value)
        Malartu::Tracking::Data.new(
          topic: res['topic'],
          value: res['value'],
          json_body: res,
          id: res['id'],
          path: res['path']
        )
      end

      def self.find(id)
        fail 'No ID given' if id.nil?
        path = "/kpi/tracking/data/#{id}"
        res = Malartu.request('get', path)
        Malartu::Tracking::Data.new(
          topic: res['topic'],
          value: res['value'],
          json_body: res,
          id: res['id'],
          path: path
        )
      end

      def self.list(starting:, ending:, page: 1, paginate: false, topic: nil)
        params = { starting: starting, ending: ending, topic: topic, page: page }.select { |_, value| !value.nil? }
        res = Malartu.request('get', '/kpi/tracking/data', params)
        data = res['data'].map do |datum|
          Malartu::Tracking::Data.new(
            topic: datum['topic'],
            value: datum['value'],
            json_body: datum,
            id: datum['id'],
            path: datum['path']
          )
        end
        page = res["page"].to_i
        return data unless paginate && res['found'].to_i >= (25 * page)
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
        Malartu::Tracking::Data.new(
          topic: res['topic'],
          value: res['value'],
          json_body: res,
          id: res['id'],
          path: path
        )
      end
    end
  end
end
