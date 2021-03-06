require 'spec_helper'

describe "worker" do

  before(:all) do
    @worker = Redmon::Worker.new
  end

  def mock_timer
    double EM::PeriodicTimer
  end

  describe "#run!" do
    it "should poll and record stats"
  end

  describe "#record_stats" do
    it "should record a new stats entry in a redis sorted set" do
      redis = mock_redis
      redis.should_receive(:zadd).with(Redmon::Redis.stats_key, 'ts', 'stats')

      @worker.stub(:stats).and_return(['ts', 'stats'])
      @worker.record_stats
    end
  end

  describe "#stats" do
    it "should fetch info, dbsize and slowlog from redis" do
      pending
      redis = mock_redis
      redis.should_receive(:info).with(no_args()).and_return({})
      redis.should_receive(:dbsize).with(no_args()).and_return(0)
      redis.should_receive(:slowlog).with(:get).and_return({})

      @worker.stub(:entires).and_return([{}])
      @worker.stats
    end
  end

  describe "#entries" do
    let (:slowlog) { [[1, 2, 3, ['cmd', 'args']]] }

    it "should parse the sortlog into hashes" do
      entries = @worker.entries slowlog
      entries.length.should == 1
      entry = entries.shift
      entry.should == {
        :id           => 1,
        :timestamp    => 2000,
        :process_time => 3,
        :command      => 'cmd args'
      }
    end
  end

  describe "#interval" do
    it "should return the configured poll interval" do
      @worker.interval.should == Redmon[:poll_interval]
    end
  end

end