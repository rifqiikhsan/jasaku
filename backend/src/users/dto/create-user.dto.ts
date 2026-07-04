import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsEnum, IsString, MinLength } from 'class-validator';
import { UserRole } from '../entities/user-role.enum';

export class CreateUserDto {
  @ApiProperty({ example: 'Rifqi' })
  @IsString()
  fullName!: string;

  @ApiProperty({ example: 'rifqi@gmail.com' })
  @IsEmail()
  email!: string;

  @ApiProperty({ example: '6281234567890' })
  @IsString()
  phone!: string;

  @ApiProperty({ example: '123456' })
  @IsString()
  @MinLength(6)
  password!: string;

  @ApiProperty({ example: 'CUSTOMER', enum: UserRole })
  @IsEnum(UserRole)
  role!: UserRole;
}
