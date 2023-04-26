class UploadResponseModel {
  final Message? message;

  UploadResponseModel({
    this.message,
  });

  UploadResponseModel.fromJson(Map<String, dynamic> json)
    : message = (json['message'] as Map<String,dynamic>?) != null ? Message.fromJson(json['message'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'message' : message?.toJson()
  };
}

class Message {
  final String? name;
  final String? owner;
  final String? creation;
  final String? modified;
  final String? modifiedBy;
  final int? idx;
  final int? docstatus;
  final String? fileName;
  final int? isPrivate;
  final int? isHomeFolder;
  final int? isAttachmentsFolder;
  final int? fileSize;
  final String? fileUrl;
  final String? folder;
  final int? isFolder;
  final String? attachedToDoctype;
  final String? attachedToName;
  final String? contentHash;
  final int? uploadedToDropbox;
  final int? uploadedToGoogleDrive;
  final String? doctype;

  Message({
    this.name,
    this.owner,
    this.creation,
    this.modified,
    this.modifiedBy,
    this.idx,
    this.docstatus,
    this.fileName,
    this.isPrivate,
    this.isHomeFolder,
    this.isAttachmentsFolder,
    this.fileSize,
    this.fileUrl,
    this.folder,
    this.isFolder,
    this.attachedToDoctype,
    this.attachedToName,
    this.contentHash,
    this.uploadedToDropbox,
    this.uploadedToGoogleDrive,
    this.doctype,
  });

  Message.fromJson(Map<String, dynamic> json)
    : name = json['name'] as String?,
      owner = json['owner'] as String?,
      creation = json['creation'] as String?,
      modified = json['modified'] as String?,
      modifiedBy = json['modified_by'] as String?,
      idx = json['idx'] as int?,
      docstatus = json['docstatus'] as int?,
      fileName = json['file_name'] as String?,
      isPrivate = json['is_private'] as int?,
      isHomeFolder = json['is_home_folder'] as int?,
      isAttachmentsFolder = json['is_attachments_folder'] as int?,
      fileSize = json['file_size'] as int?,
      fileUrl = json['file_url'] as String?,
      folder = json['folder'] as String?,
      isFolder = json['is_folder'] as int?,
      attachedToDoctype = json['attached_to_doctype'] as String?,
      attachedToName = json['attached_to_name'] as String?,
      contentHash = json['content_hash'] as String?,
      uploadedToDropbox = json['uploaded_to_dropbox'] as int?,
      uploadedToGoogleDrive = json['uploaded_to_google_drive'] as int?,
      doctype = json['doctype'] as String?;

  Map<String, dynamic> toJson() => {
    'name' : name,
    'owner' : owner,
    'creation' : creation,
    'modified' : modified,
    'modified_by' : modifiedBy,
    'idx' : idx,
    'docstatus' : docstatus,
    'file_name' : fileName,
    'is_private' : isPrivate,
    'is_home_folder' : isHomeFolder,
    'is_attachments_folder' : isAttachmentsFolder,
    'file_size' : fileSize,
    'file_url' : fileUrl,
    'folder' : folder,
    'is_folder' : isFolder,
    'attached_to_doctype' : attachedToDoctype,
    'attached_to_name' : attachedToName,
    'content_hash' : contentHash,
    'uploaded_to_dropbox' : uploadedToDropbox,
    'uploaded_to_google_drive' : uploadedToGoogleDrive,
    'doctype' : doctype
  };
}