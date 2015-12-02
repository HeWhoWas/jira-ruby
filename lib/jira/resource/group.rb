module JIRA
  module Resource

    class GroupFactory < JIRA::BaseFactory # :nodoc:
    end

    class Group < JIRA::Base
      def self.singular_path(client, key, prefix = '/')
        collection_path(client, prefix) + '?groupname=' + key + "&expand=users"
      end

      def add_user(user)
          users_url = client.options[:rest_base_path] + '/group/user'
          query_params = {:groupname => self.key_value}
          body = {:name => user}.to_json
          response = client.post(url_with_query_params(users_url, query_params), body)
          json = self.class.parse_json(response.body)
          json.map do |jira_user|
            client.User.build(jira_user)
          end
      end
    end
  end
end
