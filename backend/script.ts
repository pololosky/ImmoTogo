import { prisma } from './lib/prisma'

async function main() {
  // // Create a new user with a post
  // const user = await prisma.user.create({
  //   data: {
  //     name: 'kaleb',
  //     email: 'kaleb@gmail.com',
  //     password: "Admin123",
  //   },
  //   include:{
  //     properties: true,
  //   }
  // })
  // console.log('Created user:', user)
  // create a new property for the user
  const property = await prisma.property.create({
    data: {
      title: 'maison AKOUETE',
      description: 'villa de luxe avec piscine et jardin',
      price: 85000000,
      address: '123 Main St, Anytown, USA',
      type: 'MAISON',
      city: 'dekon',
      surface: 600,
      zipCode: '12345',
      images:["assets/villa01.jpg"],
      sellerId: 2,
    },
  })
  console.log('Created property:', property)
}

main()
  .then(async () => {
    await prisma.$disconnect()
  })
  .catch(async (e) => {
    console.error(e)
    await prisma.$disconnect()
    process.exit(1)
  })