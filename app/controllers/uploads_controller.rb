class UploadsController < ApplicationController
  before_action :set_files, only: [ :create ]
  def new
  end

  def create
    # TODO: make background jobs
    @files.each { |f| ListingCsvImportService.call(f) }

    flash.notice = "upload successful."
    render :new
  end

  private

  def upload_params
    params.expect(files: [])
  end

  def set_files
    @files = upload_params
    unless @files.present? && !@files.empty?
      redirect_to new_upload_path, status: :unprocessable_entity
    end
  end
end
