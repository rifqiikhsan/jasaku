import { User } from '../entities/user.entity';
import { UserResponse } from '../dto/user-response.dto';

export class UserMapper {
  static toResponse(user: User): UserResponse {
    const response = new UserResponse();
    response.id = user.id;
    response.fullName = user.fullName;
    response.email = user.email;
    response.role = user.role;
    response.createdAt = user.createdAt;
    response.updatedAt = user.updatedAt;
    return response;
  }
}
