require File.dirname(__FILE__) + '/test_helper'

class ActsAsCommenterTest < ActiveSupport::TestCase

  context "instance methods" do
    setup do
      @sam = Factory(:sam)
    end

    should "be defined" do
      assert @sam.respond_to?(:commented?)
      assert @sam.respond_to?(:comment)
    end
  end

  context "acts_as_commenter" do
    setup do
      @sam = Factory(:sam)
      @jon = Factory(:jon)
      @beatles = Factory(:beatles)
      @sam.comment(@jon, "Hello friend.")
      @sam.comment(@beatles, "Nice music.")
    end

    context "commented?" do
      should "return comment status" do
        assert !@jon.commented?(@sam)
        assert @sam.commented?(@beatles)
        assert @sam.commented?(@jon)
      end

      should "return commentings count" do
        assert_equal 2, @sam.commentings.count
        assert_equal 0, @jon.commentings.count
      end
    end

    context "comment on a band" do
      setup do
        @jon.comment(@beatles, "Nice music!")
      end
    
      should "set the commenter" do
        assert_equal @jon, Comment.last.commenter
      end
    
      should "set the commentable" do
        assert_equal @beatles, Comment.last.commentable
      end
    end
    
    context "private comment" do
      setup do
        @jon.comment(@beatles, "Free as a bird.", true)
      end
    
      should "not show up in the public commentings" do
        assert_equal 0, @jon.commentings.public.count
        assert_equal 1, @jon.commentings.count
      end
    end
    
    context "add a reply" do
      setup do 
        @comment = @sam.commentings.last
        @commentings_count = @jon.commentings.count
        @comment.reply(@jon, "I like it too!")
      end
      
      should "have one more commenting" do
        assert_equal @commentings_count + 1, @jon.commentings.count
      end
    end
    
    context "private conversation" do
      setup do
        @bob = Factory(:bob)
        @comment = @sam.comment(@jon, "How are you?", true)
        @comments_count = Comment.count
        @children_size = @comment.children.size
        @comment.reply(@bob, "Hey, can I join this conversation?")
      end
      
      should "not change the number of comments" do
        assert_equal @comments_count, Comment.count
        assert_equal @children_size, @comment.children.count
      end
    end
    
    context "nested replies" do
      setup do
        @comment = @sam.commentings.last
        @commentings_count = @sam.commentings.count
        @sam.comment(@comment.commentable, "This is another reply", false, @comment)
      end
      
      should "have one more commentings" do
        assert_equal @commentings_count + 1, @sam.commentings.count
      end
      
      should "have a child comment" do
        assert_equal 1, @comment.children.size
      end
    end
    
    context "destroying the commenter" do
      setup do
        @comments_count = Comment.count
        @commentings_count = @sam.commentings.count
        @jon.destroy
      end
    
      should 'have one less rating' do
        assert_equal Comment.count, @comments_count - 1
      end
      
      should "decreate the commenter's commentings count by one" do
        assert_equal @sam.commentings.count, @commentings_count - 1
      end
    end
  end
end