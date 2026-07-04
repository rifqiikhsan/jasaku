import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsEmail, IsEnum, IsOptional, IsString } from 'class-validator';
import { UserRole } from '../entities/user-role.enum';

export class UpdateUserDto {
  @ApiPropertyOptional({ example: 'Rifqi' })
  @IsOptional()
  @IsString()
  fullName?: string;

  @ApiPropertyOptional({ example: 'rifqi@gmail.com' })
  @IsOptional()
  @IsEmail()
  email?: string;

  @ApiPropertyOptional({ example: '6281234567890' })
  @IsOptional()
  @IsString()
  phone?: string;

  @ApiPropertyOptional({ example: 'CUSTOMER', enum: UserRole })
  @IsOptional()
  @IsEnum(UserRole)
  role?: UserRole;
}
