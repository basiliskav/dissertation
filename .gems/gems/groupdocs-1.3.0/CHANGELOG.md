## v1.2

**New**

* Added `Annotation::Collector` class
* Added `Collector.get!`
* Added `Collector#add!`
* Added `Collector#update!`
* Added `Collector#remove!`
* Added `Collector#executions!`
* Added `Collector#add_execution!`
* Added `Collector#fill!`
* Added `Document.templates!`
* Added `Questionnaire#executions!`
* Added `Questionnaire#collectors!`
* Added `Questionnaire#metadata!`
* Added `Questionnaire#update_metadata!`
* Added `Questionnaire#fields!`
* Added `Execution.get!`
* Added `Execution#delete!`
* Added `Execution#fill!`
* Added `Document.sign_documents!`
* Added `Document#page_images!`
* Added MIME helper

**Changes**

* Fixed `Questionnaire#create!`
* Fixed `Field#rectangle=`
* Fixed `File#download!`
* Fixed `Folder#list!` params handling (see issue #30)
* Fixed coordinates-related responses (they now have downcased fields)
* Fixed `Job#add_datasource!`
* `Questionnaire.all!` now accepts optional paging and status filter params
* New attributes for a lot of entities

**Removed**

* Removed `Questionnaire#create_execution!`


## v1.1

**New**

* Added `Annotation::Reviewer` class
* Added `Reviewer.all!`
* Added `Reviewer.set!`
* Added `Job#delete!`
* Added `Document#shared_link_access_rights!`
* Added `Document#set_shared_link_access_rights!`
* Added `Document#set_reviewers!`
* Added `Document#add_collaborotor!`
* More attributes for `User` class
* Added `Annotation#move_marker!`
* Added new `Job` action - `:compare`

**Changes**

* Moved `Annotation#collaborators!` and `Annotation#set_collaborators!` to `Document` class as it makes more sense
* `Document#set_collaborators!` now accepts options `version` parameter (default to `1`)


## v1.0

**New**

* Added fully-featured Signature API
* Added API to retrieve subscription plans
* Added `Annotation#set_access!` to control annotation access: public or private
* Added `Job.get!` to retrieve job by its identifier
* Added `Job#delete_document!`
* Added `File.upload_web!` to convert webpages to documents
* Added `File#move_to_trash!`
* Added `User.users!` to retrieve my account's users

**Changes**

* `File` and `Folder` has changed the way paths are handled. Path should no longer start with `/`
* `File.upload!` now accept hash of options as argument: `:path` to upload to, `:name` to rename file, `:description` to add description to file
* `File#move!` now accept hash of options as argument: `:name` to rename file
* `File#copy!` now accept hash of options as argument: `:name` to rename file

**Removed**

* `Document.all!` is removed (slow recursive implementation)
* `Document.find!` is removed (slow recursive implementation)
* `Document.find_all!` is removed (slow recursive implementation)
* `File.all!` is removed (slow recursive implementation)
* `File.find!` is removed (slow recursive implementation)
* `File.find_all!` is removed (slow recursive implementation)
* `Folder.all!` is removed (slow recursive implementation)
* `Folder.find!` is removed (slow recursive implementation)
* `Folder.find_all!` is removed (slow recursive implementation)
* `Extensions::LookUp` is removed (slow recursive implementation)
* `File#upload!` is removed (not really needed, use `File.upload!`)
* `Folder#rename!` is removed (has some quirks due to API, use `Folder#move!` instead)

## v0.3.11

* Fix for critical bug in `Entity#to_hash`

## v0.3.10

* Updated `Document#metadata!`
* Fixed `Folder#move!`
* Fixed `Folder#copy!`

## v0.3.9

* Added `File#upload!`
* Proper handling of `File#file_type`
* More annotation types
* `Document#datasource!` options are now optional

## v0.3.8

* Updated `Datasource for new API
* Updated `Datasource::Field` for new API
* Some minor fixes

## v0.3.7

* More flexible `Execution#owner=` and specs for it
* More flexible `Execution#executive=` and specs for it
* More flexible `Execution#approver=` and specs for it

## v0.3.6

* `Questionnaire::Execution` now returns objects for`owner`, `executive` and `approver`

## v0.3.5

* Methods to retrieve and update user profile information

## v0.3

**This release breaks backwards compatibility**

New API version uses strings for job actions, access modes, statuses, file types, etc. This release reflects corresponding changes.

## v0.2.11

* Added `Questionnaire#default_answer` and `Questionnaire#default_answer=`

## v0.2.10

* Added `Annotation#collaborators!`

## v0.2.9

* Added `Annotation#position`
* Added `Annotation#move!`

## v0.2.8

* Human-readable `Annotation#access`
* Machine-readable `Annotation#access=`
* `Document#annotations!` now handles `null` in "annotations" response

## v0.2.7

* `Job#documents!` now updates job status

## v0.2.6

* Minor `Job` and `Document` fixes

## v0.2.5

* `Document` now parses `outputs` to `Storage::File` object
* `Document` now has `output_formats` with corresponding parser
* `Document#convert!` URI was changed
* Job API methods were returning job documents in different format

## v0.2.4

* `Job` has now more attributes
* `Job#documents=` should not raise error when `nil` is passed
* Timestamps are being returned in milliseconds, while we were parsing them as seconds

## v0.2.3

* Fixed `Entity#variable_to_accessor` bugs
* Updated `Document#fields!` to always include geometry
* Added more accessors to `Rectange` (fixes `#inspect` issues)

## v0.2.2

* Updated `Folder.list!` for response changes

## v0.2.1

* `Sugar` namespace is now `Extensions`
* Removed `File#delete!` workaround

## v0.2

* `File#compress!` supports only zip, so parameter was removed
* `Errors` namespace was removed
* `BadRequestError` now shows only error message
* `File#upload!` no longer uses description, so parameter was removed
* Added `File#file_type`
* Added `File::DOCUMENT_TYPES`. `File#type` now returns document type in human-readable format
* `Folder#list!` capitalizes `:order_by` option
* Introduced `URLHelper#normalize_path`. Path is now normalized before sending request.
* HTTP methods as strings are now allowed
* Workaround for `File#delete!`
* Updated gems

## v0.1

Initial release
