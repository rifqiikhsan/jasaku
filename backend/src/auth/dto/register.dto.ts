import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsEnum, IsString, MinLength } from 'class-validator';

import { UserRole } from '../../users/entities/user-role.enum';

export class RegisterDto {
  @ApiProperty()
  @IsString()
  fullName!: string;

  @ApiProperty()
  @IsEmail()
  email!: string;

  @ApiProperty()
  @IsString()
  phone!: string;

  @ApiProperty()
  @MinLength(6)
  password!: string;

  @ApiProperty({
    enum: UserRole,
  })
  @IsEnum(UserRole)
  role!: UserRole;
}
