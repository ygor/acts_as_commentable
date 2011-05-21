require File.dirname(__FILE__) + '/test_helper'

class ActsAsCommentableTest < ActiveSupport::TestCase

  context "instance methods" do
    setup do
      @beatles = Factory(:beatles)
    end

    should "be defined" do
      assert @beatles.respond_to?(:threads)
      assert @beatles.respond_to?(:commented_by?)
    end
  end

  context "acts_as_commentable" do
    setup do
      @sam = Factory(:sam)
      @jon = Factory(:jon)
      @beatles = Factory(:beatles)
      @sam.comment(@jon, "Want to drink beer?")
    end

    context "commented_by" do
      should "return comment status" do
        assert_equal true, @jon.commented_by?(@sam)
        assert_equal false, @beatles.commented_by?(@sam)
      end
    end
    
    context "adding a reply" do
      setup do
        @comment = @jon.comments.last
        @threads_count = @jon.threads.count
        @comment.reply(@jon, "Sure, how about tonight!")
      end
      
      should "not change the threads count" do
        assert_equal @threads_count, @jon.threads.count
      end
    end

    context "adding a new comment" do
      setup do
        @threads_count = @jon.threads.count
        @jon.comment(@jon, "This is a personal reminder!")
      end
      
      should "increase the threads count by one" do
        assert_equal @threads_count + 1, @jon.threads.count
      end
    end
      
    context "destroying a commenter" do
      setup do
        @total_count = Comment.count
        @comments_count = @jon.comments.count
        @sam.destroy
      end
    
      should 'decrease comments count by one' do
        assert_equal @total_count - 1, Comment.count
        assert_equal @comments_count -1, @jon.comments.count
      end
    end
  end
end