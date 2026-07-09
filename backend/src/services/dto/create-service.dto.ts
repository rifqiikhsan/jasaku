import { ApiProperty } from '@nestjs/swagger';
import { IsArray, IsEnum, IsNumber, IsString, Matches } from 'class-validator';
import { ServiceEmojiColor } from '../entities/service.entity';

export class CreateServiceDto {
  @ApiProperty({ example: 'Beauty Service' })
  @IsString()
  serviceName!: string;

  @ApiProperty({ example: ['category-id-1', 'category-id-2'] })
  @IsArray()
  @IsString({ each: true })
  category!: string[];

  @ApiProperty({ example: 4.8 })
  @IsNumber()
  summaryRating!: number;

  @ApiProperty({ example: '2.3 km' })
  @IsString()
  distance!: string;

  @ApiProperty({ example: 120 })
  @IsNumber()
  totalReviews!: number;

  @ApiProperty({ example: 'Rp 150.000' })
  @IsString()
  priceMinimum!: string;

  @ApiProperty({ example: '💆' })
  @IsString()
  emoji!: string;

  @ApiProperty({ enum: ServiceEmojiColor, example: 'blue' })
  @IsEnum(ServiceEmojiColor)
  emojiColor!: ServiceEmojiColor;

  @ApiProperty({ example: 'Y' })
  @IsString()
  @Matches(/^[YN]$/)
  isVerification!: string;
}
