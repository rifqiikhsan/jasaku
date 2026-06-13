import { ApiProperty } from '@nestjs/swagger';
import { UserRole } from '../entities/user-role.enum';

export class UserResponse {
  @ApiProperty({ example: 'ndfhbdsf7dsfbdsf543ndfsdf' })
  id: string | undefined;

  @ApiProperty({ example: 'Rifqi' })
  fullName: string | undefined;

  @ApiProperty({ example: 'rifqi@gmail.com' })
  email: string | undefined;

  @ApiProperty({ example: 'CUSTOMER' })
  role: UserRole | undefined;

  @ApiProperty()
  createdAt: Date | undefined;

  @ApiProperty()
  updatedAt: Date | undefined;
}
