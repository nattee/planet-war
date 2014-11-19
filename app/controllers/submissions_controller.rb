class SubmissionsController < ApplicationController
  def create
    user = User.find(session[:user_id])

    @submission = Submission.new
    @submission.user = user
    @submission.language_id = 0
    if (params['file']) and (params['file']!='')
      @submission.code = File.open(params['file'].path,'r:UTF-8',&:read)
      @submission.code.encode!('UTF-8','UTF-8',invalid: :replace, replace: '')
      @submission.filename = params['file'].original_filename
      @submission.language = Language.find_by_extension(params['file'].original_filename.split('.').last)
    end
    @submission.ip_address = request.remote_ip
    @submission.state = 0

    #check for submission allow?

    #save submission
    if @submission.valid?
      if @submission.save == false then
        flash[:danger] = 'Error saving your submission'
      else
        @submission.process_new_submission
        #copy file to the specific folder
        #folder = SUBMISSION_FOLDER+"/#{@submission.id}/"
        #FileUtils.mkdir_p folder
        #FileUtils.cp(params['file'].path,folder+params['file'].original_filename)
      end
    else
      flash[:danger] = 'You must select a file for upload'
    end
    redirect_to controller: :main, action: :dashboard
  end


end
