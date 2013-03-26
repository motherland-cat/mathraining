#encoding: utf-8
class CorrectionsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user

  def create
    correction = @submission.corrections.build(params[:correction])
    correction.user = current_user
    if correction.save
      #flash[:success] = 'Réponse postée'
      redirect_to problem_submission_path(@submission.problem,
                                          @submission),
                                          flash: {success:
                                            'Réponse postée'}
    else
      flash_errors(correction)
      render 'submission/show'
    end
  end

  private

  def correct_user
    @submission = Submission.find_by_id(params[:submission_id])
    if @submission.nil? or (@submission.user != current_user and not current_user.admin)
      redirect_to root_path
    end
  end
end