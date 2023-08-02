//
//  HandleFirebaseErrorExtension.swift
//  Travelify
//
//  Created by Minh Tan Vu on 28/07/2023.
//


import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseDatabase

extension AuthErrorCode {
    var description: String? {
        switch AuthErrorCode.Code(rawValue: errorCode) {
        case .emailAlreadyInUse:
            return "Email đã tồn tại. Vui lòng thử đăng ký bằng email khác hoặc đăng nhập lại với mật khẩu"
        case .userDisabled:
            return "Người dùng đã bị vô hiệu hoá"
        case .operationNotAllowed:
            return "Tài khoản đã bị từ chối hoạt động"
        case .invalidEmail:
            return "Email không hợp lệ"
        case .wrongPassword:
            return "Sai mật khẩu. Vui lòng kiểm tra lại"
        case .userNotFound:
            return "Không tìm thấy tài khoản"
        case .networkError:
            return "Lỗi kết nối"
        case .internalError:
            return "Lỗi không xác định"
        case .invalidCustomToken:
            return "Lỗi mã xác thực"
        case .tooManyRequests:
            return "Quá nhiều yêu cầu được gửi tới hệ thống"
        default:
            return nil
        }
    }
}

extension FirestoreErrorCode {
    var description: String? {
        switch FirestoreErrorCode.Code(rawValue: errorCode) {
        case .cancelled:
            return "Yêu cầu được huỷ bỏ"
        case .unknown:
            return "Lỗi không xác định"
        case .invalidArgument:
            return "Đối số không hợp lệ"
        case .notFound:
            return "Không tìm thấy dữ liệu yêu cầu"
        case .alreadyExists:
            return "Dữ liệu đã tồn tại"
        case .permissionDenied:
            return "Không có quyền để thực hiện yêu cầu"
        case .aborted:
            return "Hoạt động bị huỷ bỏ"
        case .outOfRange:
            return "Ngoài phạm vi hợp lệ"
        case .unimplemented:
            return "Hoạt động không được thực hiện hoặc không được hỗ trợ"
        case .internal:
            return "Lỗi không xác định"
        case .unavailable:
            return "Dịch vụ hiện không khả dụng. Vui lòng thử lại"
        case .unauthenticated:
            return "Yêu cầu chưa được xác thực hợp lệ"
        default:
            return nil
        }
    }
}


/*
public extension Error {
    var localizedDescription: String {
        let error = self as NSError
        if error.domain == AuthErrorDomain {
            if let code = AuthErrorCode.Code(rawValue: error.code) {
                if let errorString = code.description {
                    return errorString
                }
            }
        }else if error.domain == FirestoreErrorDomain {
            if let code = FirestoreErrorCode.Code(rawValue: error.code) {
                if let errorString = code.description {
                   return errorString
                }
            }
        }
        return error.localizedDescription
    }
}
*/
