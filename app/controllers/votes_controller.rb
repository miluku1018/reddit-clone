class VotesController < ApplicationController
  def create
    post_id = params[:vote][:post_id]
    vote = Vote.new(vote_params)
    vote.account_id = current_account.id
    
    #check if vote by this user exists
    existing_vote = Vote.where(account_id: current_account.id, post_id: post_id)
    respon_to do |format|
      format.js {
        if existing_vote.size > 0
          #destroy existing vote
          existing_vote.first.destroy
        else
          #save new vote
          if vote.save
            @success = true
          else
            @success = false
          end  

          @post = Post.find(post_id)
          @total_upvotes = @psot.upvotes 
          @total_downvotes = @psot.downvotes
        end
        render "votes/create" 
      }
    end
  end

  private
  def vote_params
    params.require(:vote).permit(:upvote, :post_id)
  end
end
