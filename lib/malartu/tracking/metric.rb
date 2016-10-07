module Malartu
  module Tracking
    # Tracking::Metric lets you store data is the Malartu system
    # Learn more at: TODO
    class Metric
      attr_accessor :id, :topic, :value, :path, :json_body
      def initialize(id: nil, topic: nil, value: 1, path: nil, json_body: nil)
        @id = id
        @topic = topic
        @value = value
        @path = path
        @json_body = json_body
      end

      def self.create(topic: nil, value: 1)
        fail 'No topic' if topic.nil?
        res = Malartu.request('post', '/trackings/metrics', topic: topic, value: value)
        Malartu::Tracking::Metric.new(
          topic: res['topic'],
          value: res['value'],
          json_body: res,
          id: res['id'],
          path: res['path']
        )
      end

      def self.find(id)
        fail 'No ID given' if id.nil?
        path = "/trackings/metrics/#{id}"
        res = Malartu.request('get', path, id: id, model: 'Tracking::Metric')
        Malartu::Tracking::Metric.new(
          topic: res['topic'],
          value: res['value'],
          json_body: res,
          id: res['id'],
          path: path
        )
      end

      def self.list(starting, ending, topic = nil)
        # TODO verify date formats
        res = Malartu.request('get', '/trackings/metrics', starting: starting, ending: ending, topic: topic)
        res
        # TODO build list of metrics
      end

      def self.update(id, topic: nil, value: 1)
        fail 'No Topic' if topic.nil?
        params = {}
        params[:topic] = topic unless topic.nil?
        params[:value] = value unless value.nil?
        fail 'No parameters to send' if params == {}
        path = "/trackings/metrics/#{id}"
        res = Malartu.request('patch', path, params)
        Malartu::Tracking::Metric.new(
          topic: res['topic'],
          value: res['value'],
          json_body: res,
          id: res['id'],
          path: path
        )
      end

      # Topics available for all metrics
      class Topic
        def self.list
          return Malartu.topics unless Malartu.topics.nil?
          res = Malartu.request('get', '/trackings/metrics/topics')
          Malartu.topics = res['topics'] # TODO change api fields/url
          res['topics']
        end
      end
    end
  end
end
