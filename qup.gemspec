# -*- encoding: utf-8 -*-
# stub: qup 1.4.2 ruby lib

Gem::Specification.new do |s|
  s.name = "qup"
  s.version = "1.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jeremy Hinegardner"]
  s.date = "2015-02-18"
  s.description = "Qup is a generalized API for Message Queue and Publish/Subscribe messaging patterns with the ability to plug in an appropriate messaging infrastructure based upon your needs. Qup ships with support for (https://github.com/robey/kestrel), (http://redis.io), and a filesystem infrastructure based on (https://rubygems.org/gems/maildir). Additional Adapters will be developed as needs arise. (https://github.com/copiousfreetime/qup/issues) to have a new Adapter created. Pull requests gladly accepted."
  s.email = "jeremy@copiousfreetime.org"
  s.extra_rdoc_files = ["ADAPTER_API.md", "CONTRIBUTING.md", "HISTORY.md", "Manifest.txt", "README.md"]
  s.files = [".autotest", ".gemtest", "ADAPTER_API.md", "CONTRIBUTING.md", "HISTORY.md", "LICENSE", "Manifest.txt", "README.md", "Rakefile", "lib/qup.rb", "lib/qup/adapter.rb", "lib/qup/adapter/kestrel.rb", "lib/qup/adapter/kestrel/destination.rb", "lib/qup/adapter/kestrel/queue.rb", "lib/qup/adapter/kestrel/topic.rb", "lib/qup/adapter/maildir.rb", "lib/qup/adapter/maildir/queue.rb", "lib/qup/adapter/maildir/topic.rb", "lib/qup/adapter/redis.rb", "lib/qup/adapter/redis/connection.rb", "lib/qup/adapter/redis/queue.rb", "lib/qup/adapter/redis/topic.rb", "lib/qup/backoff_sleeper.rb", "lib/qup/batch_consumer.rb", "lib/qup/consumer.rb", "lib/qup/message.rb", "lib/qup/producer.rb", "lib/qup/publisher.rb", "lib/qup/queue_api.rb", "lib/qup/session.rb", "lib/qup/subscriber.rb", "lib/qup/topic_api.rb", "spec/qup/adapter/kestrel/queue_spec.rb", "spec/qup/adapter/kestrel/topic_spec.rb", "spec/qup/adapter/kestrel_context.rb", "spec/qup/adapter/kestrel_spec.rb", "spec/qup/adapter/maildir/queue_spec.rb", "spec/qup/adapter/maildir/topic_spec.rb", "spec/qup/adapter/maildir_context.rb", "spec/qup/adapter/maildir_spec.rb", "spec/qup/adapter/redis/queue_spec.rb", "spec/qup/adapter/redis/topic_spec.rb", "spec/qup/adapter/redis_context.rb", "spec/qup/adapter/redis_spec.rb", "spec/qup/adapter_spec.rb", "spec/qup/backoff_sleeper_sleeper_spec.rb", "spec/qup/batch_consumer_spec.rb", "spec/qup/consumer_spec.rb", "spec/qup/message_spec.rb", "spec/qup/producer_spec.rb", "spec/qup/queue_api_spec.rb", "spec/qup/session_spec.rb", "spec/qup/shared_adapter_examples.rb", "spec/qup/shared_queue_examples.rb", "spec/qup/shared_topic_examples.rb", "spec/qup/topic_api_spec.rb", "spec/qup_spec.rb", "spec/spec_helper.rb", "tasks/default.rake", "tasks/this.rb"]
  s.homepage = "http://github.com/copiousfreetime/qup"
  s.rdoc_options = ["--main", "README.md", "--markup", "tomdoc"]
  s.rubygems_version = "2.4.6"
  s.summary = "Qup is a generalized API for Message Queue and Publish/Subscribe messaging patterns with the ability to plug in an appropriate messaging infrastructure based upon your needs."
  s.test_files = ["spec/qup/adapter/kestrel/queue_spec.rb", "spec/qup/adapter/kestrel/topic_spec.rb", "spec/qup/adapter/kestrel_context.rb", "spec/qup/adapter/kestrel_spec.rb", "spec/qup/adapter/maildir/queue_spec.rb", "spec/qup/adapter/maildir/topic_spec.rb", "spec/qup/adapter/maildir_context.rb", "spec/qup/adapter/maildir_spec.rb", "spec/qup/adapter/redis/queue_spec.rb", "spec/qup/adapter/redis/topic_spec.rb", "spec/qup/adapter/redis_context.rb", "spec/qup/adapter/redis_spec.rb", "spec/qup/adapter_spec.rb", "spec/qup/backoff_sleeper_sleeper_spec.rb", "spec/qup/batch_consumer_spec.rb", "spec/qup/consumer_spec.rb", "spec/qup/message_spec.rb", "spec/qup/producer_spec.rb", "spec/qup/queue_api_spec.rb", "spec/qup/session_spec.rb", "spec/qup/shared_adapter_examples.rb", "spec/qup/shared_queue_examples.rb", "spec/qup/shared_topic_examples.rb", "spec/qup/topic_api_spec.rb", "spec/qup_spec.rb", "spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<maildir>, ["~> 2.1.0"])
      s.add_development_dependency(%q<kjess>, ["~> 1.2"])
      s.add_development_dependency(%q<redis>, ["~> 3.0"])
      s.add_development_dependency(%q<rake>, ["~> 10.1.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.14.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0"])
    else
      s.add_dependency(%q<maildir>, ["~> 2.1.0"])
      s.add_dependency(%q<kjess>, ["~> 1.2"])
      s.add_dependency(%q<redis>, ["~> 3.0"])
      s.add_dependency(%q<rake>, ["~> 10.1.0"])
      s.add_dependency(%q<rspec>, ["~> 2.14.0"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
    end
  else
    s.add_dependency(%q<maildir>, ["~> 2.1.0"])
    s.add_dependency(%q<kjess>, ["~> 1.2"])
    s.add_dependency(%q<redis>, ["~> 3.0"])
    s.add_dependency(%q<rake>, ["~> 10.1.0"])
    s.add_dependency(%q<rspec>, ["~> 2.14.0"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
  end
end
