class ConvertToActiveStorageForPictures < ActiveRecord::Migration[5.2]
  require 'open-uri'

  def up
    if Rails.env.production?
      get_blob_id = 'LASTVAL()' # postgres
      
      active_storage_blob_statement = ActiveRecord::Base.connection.raw_connection.prepare('active_storage_blob_statement', <<-SQL)
        INSERT INTO active_storage_blobs (
          key, filename, content_type, metadata, byte_size, checksum, created_at
        ) VALUES ($1, $2, $3, '{}', $4, $5, $6)
      SQL

      active_storage_attachment_statement = ActiveRecord::Base.connection.raw_connection.prepare('active_storage_attachment_statement', <<-SQL)
        INSERT INTO active_storage_attachments (
          name, record_type, record_id, blob_id, created_at
        ) VALUES ($1, $2, $3, #{get_blob_id}, $4)
      SQL
    else
      get_blob_id = 'LAST_INSERT_ROWID()' # sqlite
      
      active_storage_blob_statement = ActiveRecord::Base.connection.raw_connection.prepare(<<-SQL)
        INSERT INTO active_storage_blobs (
          `key`, filename, content_type, metadata, byte_size, checksum, created_at
        ) VALUES ($1, $2, $3, '{}', $4, $5, $6)
      SQL

      active_storage_attachment_statement = ActiveRecord::Base.connection.raw_connection.prepare(<<-SQL)
        INSERT INTO active_storage_attachments (
          name, record_type, record_id, blob_id, created_at
        ) VALUES ($1, $2, $3, #{get_blob_id}, $4)
      SQL
    end

    Rails.application.eager_load!
    models = ActiveRecord::Base.descendants.reject(&:abstract_class?)

    transaction do
      Picture.find_each.each do |instance|
        if instance.send("image").path.blank?
          next
        end

        if Rails.env.production? # postgres
          ActiveRecord::Base.connection.raw_connection.exec_prepared(
            'active_storage_blob_statement', [
              key(instance, "image"),
              instance.send("image_file_name"),
              instance.send("image_content_type"),
              instance.send("image_file_size"),
              checksum(instance.send("image")),
              instance.image_updated_at.iso8601
            ])

          ActiveRecord::Base.connection.raw_connection.exec_prepared(
            'active_storage_attachment_statement', [
              "image",
              Picture.name,
              instance.id,
              instance.image_updated_at.iso8601,
            ])
        else # sqlite
          active_storage_blob_statement.execute([
              key(instance, "image"),
              instance.send("image_file_name"),
              instance.send("image_content_type"),
              instance.send("image_file_size"),
              checksum(instance.send("image")),
              instance.image_updated_at.iso8601
            ])
            
          active_storage_attachment_statement.execute([
              "image",
              Picture.name,
              instance.id,
              instance.image_updated_at.iso8601,
            ])
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def key(instance, attachment)
    SecureRandom.uuid
    # Alternatively:
    # instance.send("#{attachment}_file_name")
  end

  def checksum(attachment)
    # local files stored on disk:
    url = attachment.path
    Digest::MD5.base64digest(File.read(url))
  end
end
