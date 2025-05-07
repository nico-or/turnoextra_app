module Admin
  class UploadsController < AdminController
    before_action :set_files, only: [ :create ]

    def create
      # TODO: make background jobs
      @files.each { |f| ListingCsvImportService.call(f) }

      flash[:notice] = "Upload successful."
      render :new, status: :created
    end

    private

    def upload_params
      params.expect(files: [])
    end

    def set_files
      @files = upload_params
      @files.select! { |f| valid_format?(f) }

      if @files.empty?
        flash[:error] = "No valid files were uploaded."
        render :new, status: :unprocessable_entity
      end
    end

    def valid_format?(file)
      valid_extensions = %w[.csv]
      valid_extensions.include?(File.extname(file).downcase)
    end
  end
end
