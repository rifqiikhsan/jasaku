import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { ServicesService } from './services.service';
import {
  Service as ServiceEntity,
  ServiceEmojiColor,
} from './entities/service.entity';
import { Category } from '../categories/entities/category.entity';

describe('ServicesService', () => {
  let service: ServicesService;
  let repo: {
    findOne: jest.Mock;
    create: jest.Mock;
    save: jest.Mock;
    find: jest.Mock;
    update: jest.Mock;
    delete: jest.Mock;
  };
  let categoryRepo: {
    find: jest.Mock;
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ServicesService,
        {
          provide: getRepositoryToken(ServiceEntity),
          useValue: {
            findOne: jest.fn(),
            create: jest.fn(),
            save: jest.fn(),
            find: jest.fn(),
            update: jest.fn(),
            delete: jest.fn(),
          },
        },
        {
          provide: getRepositoryToken(Category),
          useValue: {
            find: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<ServicesService>(ServicesService);
    repo = module.get(getRepositoryToken(ServiceEntity));
    categoryRepo = module.get(getRepositoryToken(Category));
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should create a service and return status 201', async () => {
    repo.findOne.mockResolvedValue(null);
    categoryRepo.find.mockResolvedValue([{ id: 'cat-1' }]);
    const dto = {
      serviceName: 'Massage Therapy',
      category: ['cat-1'],
      summaryRating: 4.8,
      distance: '2.3 km',
      totalReviews: 120,
      priceMinimum: 'Rp 150.000',
      emoji: '💆',
      emojiColor: ServiceEmojiColor.BLUE,
      isVerification: 'Y',
    };

    const createdEntity = { id: 'svc-1', ...dto };
    repo.create.mockReturnValue(createdEntity);
    repo.save.mockResolvedValue(createdEntity);

    const result = await service.create(dto);

    expect(repo.findOne).toHaveBeenCalled();
    expect(categoryRepo.find).toHaveBeenCalledWith({
      where: [{ id: 'cat-1' }],
    });
    expect(repo.create).toHaveBeenCalledWith(dto);
    expect(repo.save).toHaveBeenCalledWith(createdEntity);
    expect(result).toEqual({ status: 201, data: 'svc-1' });
  });

  it('should return category details with id and catDesc in findAll response', async () => {
    repo.find.mockResolvedValue([
      {
        id: 'svc-1',
        serviceName: 'Massage Therapy',
        category: ['cat-1'],
      },
    ]);
    categoryRepo.find.mockResolvedValue([{ id: 'cat-1', catDesc: 'Wellness' }]);

    const result = await service.findAll();

    expect(result.data[0].category).toEqual([
      { id: 'cat-1', catDesc: 'Wellness' },
    ]);
  });
});
